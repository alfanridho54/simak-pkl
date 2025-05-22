<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\AbsenResource;
use App\Models\Absen;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;

class AbsenController extends Controller
{
    public function index()
{
    $user = Auth::user();

    if ($user->role === 'mahasiswa') {
        $data = Absen::with('dataPkl.mahasiswa') // eager load
            ->whereHas('dataPkl', function ($query) use ($user) {
                $query->where('users_id', $user->id);
            })->get();
    } elseif ($user->role === 'dosen') {
        $data = Absen::with('dataPkl.mahasiswa') // eager load
            ->whereHas('dataPkl', function ($query) use ($user) {
                $query->where('dosen_pembimbing', $user->id);
            })->get();
    } else {
        $data = Absen::with('dataPkl.mahasiswa')->get(); // default load all
    }

    return new AbsenResource(true, 'List Data Absen', $data);
}


    public function show($id)
    {
        $absen = Absen::find($id);
        return new AbsenResource(true, 'Detail Data Absen', $absen);
    }

   public function store(Request $request)
{
    $user = Auth::user();

    // Cek apakah user punya data_pkl
    $dataPkl = \App\Models\DataPkl::where('users_id', $user->id)->first();

    if (!$dataPkl) {
        return response()->json([
            'success' => false,
            'message' => 'Data PKL tidak ditemukan untuk user ini.',
        ], 404);
    }

    // Validasi
    $validator = Validator::make($request->all(), [
        'location' => 'required|string',
        'status'   => 'required|in:hadir,izin,alfa',
        'date'     => 'required|date',
    ]);

    if ($validator->fails()) return response()->json($validator->errors(), 422);

    // Buat data absen
    $absen = Absen::create([
        'location'     => $request->location,
        'status'       => $request->status,
        'date'         => $request->date,
        'data_pkl_id'  => $dataPkl->id,
    ]);

    return new AbsenResource(true, 'Absen berhasil disimpan', $absen);
}




    public function update(Request $request, $id)
    {
        $absen = Absen::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'location'     => 'sometimes|required|string',
            'status'       => 'sometimes|required|in:hadir,izin,alfa',
            'date'         => 'sometimes|required|date',
            'data_pkl_id'  => 'sometimes|required|exists:data_pkl,id',
        ]);

        if ($validator->fails()) return response()->json($validator->errors(), 422);

        $absen->update($request->all());
        return new AbsenResource(true, 'Data Absen Berhasil Diupdate', $absen);
    }

    public function destroy($id)
    {
        $absen = Absen::find($id);
        $absen->delete();
        return new AbsenResource(true, 'Data Absen Berhasil Dihapus', $absen);
    }


}
