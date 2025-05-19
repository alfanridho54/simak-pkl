<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\LaporanPklResource;
use App\Models\LaporanPkl;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;

class LaporanPklController extends Controller
{
    public function index()
{
    $user = Auth::user();

    if ($user->role === 'mahasiswa') {
        $data = LaporanPkl::whereHas('dataPkl', function ($query) use ($user) {
            $query->where('users_id', $user->id);
        })->get();
    } elseif ($user->role === 'dosen') {
        $data = LaporanPkl::whereHas('dataPkl', function ($query) use ($user) {
            $query->where('dosen_pembimbing', $user->id);
        })->get();
    } else {
        return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
    }

    return new LaporanPklResource(true, 'Data Laporan PKL berhasil diambil', $data);
}


    public function show($id)
    {
        $data = LaporanPkl::findOrFail($id);
        return new LaporanPklResource(true, 'Detail Laporan PKL', $data);
    }

    public function store(Request $request)
{
    $user = Auth::user();

    // cari data_pkl milik mahasiswa yang sedang login
    $dataPkl = $user->dataPkl()->first();

    if (!$dataPkl) {
        return response()->json([
            'success' => false,
            'message' => 'Data PKL belum diisi oleh mahasiswa',
        ], 422);
    }

    $validator = Validator::make($request->all(), [
        'report_date'     => 'required|date',
        'file_attachment' => 'required|string',
        'status'          => 'required|string',
    ]);

    if ($validator->fails()) return response()->json($validator->errors(), 422);

    $laporan = LaporanPkl::create([
        'report_date'     => $request->report_date,
        'file_attachment' => $request->file_attachment,
        'status'          => $request->status,
        'data_pkl_id'     => $dataPkl->id,
        'users_id'        => $user->id
    ]);

    return new LaporanPklResource(true, 'Laporan PKL berhasil ditambahkan', $laporan);
}


    public function update(Request $request, $id)
    {
        $laporan = LaporanPkl::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'report_date'     => 'sometimes|required|date',
            'file_attachment' => 'sometimes|required|string',
            'status'          => 'sometimes|required|string',
        ]);

        if ($validator->fails()) return response()->json($validator->errors(), 422);

        $laporan->update($request->only(['report_date', 'file_attachment', 'status']));
        return new LaporanPklResource(true, 'Laporan PKL Berhasil Diupdate', $laporan);
    }

    public function destroy($id)
    {
        $laporan = LaporanPkl::findOrFail($id);
        $laporan->delete();
        return new LaporanPklResource(true, 'Laporan PKL Berhasil Dihapus', $laporan);
    }
}
