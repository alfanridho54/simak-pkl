<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\LaporanPklResource;
use App\Models\LaporanPkl;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class LaporanPklController extends Controller
{
    public function index()
    {
        $data = LaporanPkl::all();
        return new LaporanPklResource(true, 'List Laporan PKL', $data);
    }

    public function show($id)
    {
        $data = LaporanPkl::findOrFail($id);
        return new LaporanPklResource(true, 'Detail Laporan PKL', $data);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'report_date'     => 'required|date',
            'file_attachment' => 'required|string',
            'status'          => 'required|string',
            'users_id'        => 'required|exists:users,id',
        ]);

        if ($validator->fails()) return response()->json($validator->errors(), 422);

        $data = LaporanPkl::create($request->all());
        return new LaporanPklResource(true, 'Laporan PKL Berhasil Ditambahkan', $data);
    }

    public function update(Request $request, $id)
    {
        $laporan = LaporanPkl::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'report_date'     => 'sometimes|required|date',
            'file_attachment' => 'sometimes|required|string',
            'status'          => 'sometimes|required|string',
            'users_id'        => 'sometimes|required|exists:users,id',
        ]);

        if ($validator->fails()) return response()->json($validator->errors(), 422);

        $laporan->update($request->all());
        return new LaporanPklResource(true, 'Laporan PKL Berhasil Diupdate', $laporan);
    }

    public function destroy($id)
    {
        $laporan = LaporanPkl::findOrFail($id);
        $laporan->delete();
        return new LaporanPklResource(true, 'Laporan PKL Berhasil Dihapus', $laporan);
    }



}
