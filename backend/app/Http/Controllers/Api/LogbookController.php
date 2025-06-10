<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\LogbookResource;
use App\Models\DataPkl;
use App\Models\Logbook;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use PDF; 

class LogbookController extends Controller
{

    public function index()
    {
        $user = auth()->user();
        if ($user->role === 'mahasiswa') {
            $data = Logbook::with('dataPkl')->whereHas('dataPkl', fn($q) => $q->where('users_id', $user->id))->get();
        } elseif ($user->role === 'dosen') {
            $data = Logbook::with('dataPkl.mahasiswa')->whereHas('dataPkl', fn($q) => $q->where('dosen_pembimbing', $user->id))->get();
        } else {
            $data = Logbook::with('dataPkl.mahasiswa')->get();
        }
        return new LogbookResource(true, 'List Logbook', $data);
    }
    public function show($id) { /* ... */ }

    public function store(Request $request)
    {
        $user = auth()->user();
        if ($user->role !== 'mahasiswa') {
            return response()->json(['success' => false, 'message' => 'Hanya mahasiswa yang bisa mengisi logbook'], 403);
        }

        $validator = Validator::make($request->all(), [
            'week_number' => 'required|integer',
            'kegiatan' => 'required|string', 
        ]);

        if ($validator->fails()) return response()->json($validator->errors(), 422);

        $dataPkl = DataPkl::where('users_id', $user->id)->first();
        if (!$dataPkl) {
            return response()->json(['success' => false, 'message' => 'Data PKL tidak ditemukan'], 404);
        }

        $data = Logbook::create([
            'week_number' => $request->week_number,
            'file_pdf'    => 'generated_on_request',
            'kegiatan' => $request->kegiatan,
            'data_pkl_id' => $dataPkl->id,
        ]);

        return new LogbookResource(true, 'Logbook berhasil ditambahkan', $data);
    }

    public function update(Request $request, $id)
    {
        $user = auth()->user();
        $logbook = Logbook::findOrFail($id);
        $dataPkl = DataPkl::where('users_id', $user->id)->first();
        if ($user->role !== 'mahasiswa' || !$dataPkl || $logbook->data_pkl_id !== $dataPkl->id) {
            return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
        }

        $validator = Validator::make($request->all(), [
            'week_number' => 'sometimes|required|integer',
            'kegiatan' => 'sometimes|required|string',
        ]);
        if ($validator->fails()) return response()->json($validator->errors(), 422);
        
        $logbook->update($request->only(['week_number', 'kegiatan'])); 
        return new LogbookResource(true, 'Logbook berhasil diperbarui', $logbook);
    }


    public function destroy($id)
    {
        
        $logbook = Logbook::findOrFail($id);
        $logbook->delete();
        return new LogbookResource(true, 'Logbook berhasil dihapus', null);
    }

    
    public function exportPDF($id)
    {
        $logbook = Logbook::with(['dataPkl.mahasiswa', 'dataPkl.dosenPembimbing'])->find($id);
        if (!$logbook) {
            return response()->json(['success' => false, 'message' => 'Logbook tidak ditemukan'], 404);
        }

       
        $user = auth()->user();
        $isOwner = $logbook->dataPkl->users_id === $user->id;
        $isDosen = $logbook->dataPkl->dosen_pembimbing === $user->id;
        if ($user->role !== 'admin' && !$isOwner && !$isDosen) {
             return response()->json(['success' => false, 'message' => 'Tidak diizinkan mengakses PDF ini'], 403);
        }

        $data = ['logbook' => $logbook];
        $pdf = PDF::loadView('pdf.logbook_pdf', $data);
        $fileName = 'logbook_minggu_' . $logbook->week_number . '_' . ($logbook->dataPkl->mahasiswa->name ?? 'mhs') . '.pdf';
        
       
        return $pdf->download($fileName);
    }
}