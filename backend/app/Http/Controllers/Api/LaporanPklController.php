<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\LaporanPklResource;
use App\Models\LaporanPkl;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use PDF;

class LaporanPklController extends Controller
{
    public function index()
{
    $user = Auth::user();

    if ($user->role === 'mahasiswa') {
            $data = LaporanPkl::with(['mahasiswa', 'dataPkl'])
                ->where('users_id', $user->id)
                ->get();
        } elseif ($user->role === 'dosen') {
            $data = LaporanPkl::with(['mahasiswa', 'dataPkl'])
                ->whereHas('dataPkl', function ($query) use ($user) {
                    $query->where('dosen_pembimbing', $user->id);
                })->get();
        } else {
            $data = LaporanPkl::with(['mahasiswa', 'dataPkl'])->get();
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
        $dataPkl = $user->dataPkl()->first();
        if (!$dataPkl) {
            return response()->json(['success' => false, 'message' => 'Data PKL belum diisi oleh mahasiswa'], 422);
        }

        $validator = Validator::make($request->all(), [
            'report_date'     => 'required|date',
            'file_attachment' => 'required|file|mimes:pdf,doc,docx|max:5120', 
            'status'          => 'required|string',
        ]);
        if ($validator->fails()) return response()->json($validator->errors(), 422);

  
        $filePath = null;
        if ($request->hasFile('file_attachment')) {
            $file = $request->file('file_attachment');
            $fileName = 'laporan_pkl_' . time() . '_' . $file->hashName();
            $filePath = $file->storeAs('laporan_pkl', $fileName, 'public');
        }

        $laporan = LaporanPkl::create([
            'report_date'     => $request->report_date,
            'file_attachment' => $filePath,
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
            'file_attachment' => 'sometimes|nullable|file|mimes:pdf,doc,docx|max:5120',
            'status'          => 'sometimes|required|string',
        ]);
        if ($validator->fails()) return response()->json($validator->errors(), 422);

        $updateData = $request->only(['report_date', 'status']);
        if ($request->hasFile('file_attachment')) {
            if ($laporan->getRawOriginal('file_attachment')) {
                Storage::disk('public')->delete($laporan->getRawOriginal('file_attachment'));
            }
            $file = $request->file('file_attachment');
            $fileName = 'laporan_pkl_' . time() . '_' . $file->hashName();
            $filePath = $file->storeAs('laporan_pkl', $fileName, 'public');
            $updateData['file_attachment'] = $filePath;
        }

        $laporan->update($updateData);
        return new LaporanPklResource(true, 'Laporan PKL Berhasil Diupdate', $laporan);
    }

    public function destroy($id)
    {
        $laporan = LaporanPkl::findOrFail($id);

        if ($laporan->getRawOriginal('file_attachment')) {
            Storage::disk('public')->delete($laporan->getRawOriginal('file_attachment'));
        }

        $laporan->delete();
        return new LaporanPklResource(true, 'Laporan PKL Berhasil Dihapus', null);
    }
}
