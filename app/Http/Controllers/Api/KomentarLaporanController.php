<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\KomentarLaporanResource;
use App\Models\KomentarLaporan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;

class KomentarLaporanController extends Controller
{
    public function index()
    {
        $user = Auth::user();

        if ($user->role === 'mahasiswa') {
            $data = KomentarLaporan::with('laporanPkl')
                ->whereHas('laporanPkl', function ($query) use ($user) {
                    $query->where('users_id', $user->id);
                })->get();

        } elseif ($user->role === 'dosen') {
            $data = KomentarLaporan::with('laporanPkl.mahasiswa.dataPkl')
                ->whereHas('laporanPkl.mahasiswa.dataPkl', function ($query) use ($user) {
                    $query->where('dosen_pembimbing', $user->id);
                })->get();

        } else {
            return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
        }

        return new KomentarLaporanResource(true, 'Data Komentar Laporan berhasil diambil', $data);
    }

    public function show($id)
    {
        $data = KomentarLaporan::findOrFail($id);
        return new KomentarLaporanResource(true, 'Detail Komentar Laporan', $data);
    }

    public function store(Request $request)
{
    $user = Auth::user();

    if ($user->role !== 'dosen') {
        return response()->json(['success' => false, 'message' => 'Hanya dosen yang dapat memberikan komentar.'], 403);
    }

    $validator = Validator::make($request->all(), [
        'laporan_pkl_id' => 'required|exists:laporan_pkl,id',
        'comment'        => 'required|string',
    ]);

    if ($validator->fails()) return response()->json($validator->errors(), 422);

    $data = KomentarLaporan::create([
        'laporan_pkl_id' => $request->laporan_pkl_id,
        'comment'        => $request->comment,
        'dosen_id'       => Auth::id(),
    ]);

    return new KomentarLaporanResource(true, 'Komentar Laporan berhasil ditambahkan', $data);
}


    public function update(Request $request, $id)
{
    $user = Auth::user();
    $komentar = KomentarLaporan::findOrFail($id);

    if ($user->role !== 'dosen' || $komentar->dosen_id !== $user->id) {
        return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
    }

    $validator = Validator::make($request->all(), [
        'laporan_pkl_id' => 'sometimes|required|exists:laporan_pkl,id',
        'comment'        => 'sometimes|required|string',
    ]);

    if ($validator->fails()) return response()->json($validator->errors(), 422);

    $komentar->update($request->only(['laporan_pkl_id', 'comment']));
    return new KomentarLaporanResource(true, 'Komentar berhasil diupdate', $komentar);
}


   public function destroy($id)
{
    $user = Auth::user();
    $komentar = KomentarLaporan::findOrFail($id);

    if ($user->role !== 'dosen' || $komentar->dosen_id !== $user->id) {
        return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
    }

    $komentar->delete();
    return new KomentarLaporanResource(true, 'Komentar berhasil dihapus', $komentar);
}

public function getByLaporan($laporan_id)
{
    $komentar = KomentarLaporan::where('laporan_pkl_id', $laporan_id)
                ->with('dosen')
                ->get();

    return new KomentarLaporanResource(true, 'Komentar untuk Laporan ID: ' . $laporan_id, $komentar);
}


}
