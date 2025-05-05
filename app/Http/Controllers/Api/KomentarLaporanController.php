<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\KomentarLaporanResource;
use App\Models\KomentarLaporan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class KomentarLaporanController extends Controller
{
    public function index()
    {
        $data = KomentarLaporan::all();
        return new KomentarLaporanResource(true, 'List Komentar Laporan', $data);
    }

    public function show($id)
    {
        $data = KomentarLaporan::findOrFail($id);
        return new KomentarLaporanResource(true, 'Detail Komentar Laporan', $data);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'laporan_pkl_id' => 'required|exists:laporan_pkl,id',
            'dosen_id'       => 'required|exists:users,id',
            'comment'        => 'required|string',
        ]);

        if ($validator->fails()) return response()->json($validator->errors(), 422);

        $data = KomentarLaporan::create($request->all());
        return new KomentarLaporanResource(true, 'Komentar Berhasil Ditambahkan', $data);
    }

    public function update(Request $request, $id)
    {
        $komentar = KomentarLaporan::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'laporan_pkl_id' => 'sometimes|required|exists:laporan_pkl,id',
            'dosen_id'       => 'sometimes|required|exists:users,id',
            'comment'        => 'sometimes|required|string',
        ]);

        if ($validator->fails()) return response()->json($validator->errors(), 422);

        $komentar->update($request->all());
        return new KomentarLaporanResource(true, 'Komentar Berhasil Diupdate', $komentar);
    }

    public function destroy($id)
    {
        $komentar = KomentarLaporan::findOrFail($id);
        $komentar->delete();
        return new KomentarLaporanResource(true, 'Komentar Berhasil Dihapus', $komentar);
    }



}
