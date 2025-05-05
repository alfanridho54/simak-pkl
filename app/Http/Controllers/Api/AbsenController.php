<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\AbsenResource;
use App\Models\Absen;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class AbsenController extends Controller
{
    public function index()
    {
        $absen = Absen::all();
        return new AbsenResource(true, 'List Data Absen', $absen);
    }

    public function show($id)
    {
        $absen = Absen::find($id);
        return new AbsenResource(true, 'Detail Data Absen', $absen);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'location'     => 'required|string',
            'status'       => 'required|in:hadir,izin,alfa',
            'date'         => 'required|date',
            'data_pkl_id'  => 'required|exists:data_pkl,id',
        ]);

        if ($validator->fails()) return response()->json($validator->errors(), 422);

        $absen = Absen::create($request->all());
        return new AbsenResource(true, 'Data Absen Berhasil Ditambahkan', $absen);
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
