<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\LogbookResource;
use App\Models\Logbook;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class LogbookController extends Controller
{
    public function index()
    {
        $user = auth()->user();

        if ($user->role === 'mahasiswa') {
            $data = Logbook::with('dataPkl')
                ->whereHas('dataPkl', function ($query) use ($user) {
                    $query->where('users_id', $user->id);
                })->get();

        } elseif ($user->role === 'dosen') {
            $data = Logbook::with('dataPkl.mahasiswa')
                ->whereHas('dataPkl', function ($query) use ($user) {
                    $query->where('dosen_pembimbing', $user->id);
                })->get();

        } else {
            $data = Logbook::with('dataPkl')->get();
        }

        return new LogbookResource(true, 'List Logbook', $data);
    }


    public function show($id)
    {
        $data = Logbook::find($id);
        return new LogbookResource(true, 'Detail Logbook', $data);
    }

    public function store(Request $request)
    {
        $user = auth()->user();

        if ($user->role !== 'mahasiswa') {
            return response()->json(['success' => false, 'message' => 'Hanya mahasiswa yang bisa mengisi logbook'], 403);
        }

        $validator = Validator::make($request->all(), [
            'week_number' => 'required|integer',
            'file_pdf'    => 'required|string',
        ]);

        if ($validator->fails()) return response()->json($validator->errors(), 422);

        // Ambil data_pkl_id milik mahasiswa yang sedang login
        $dataPkl = \App\Models\DataPkl::where('users_id', $user->id)->first();

        if (!$dataPkl) {
            return response()->json(['success' => false, 'message' => 'Data PKL tidak ditemukan'], 404);
        }

        $data = Logbook::create([
            'week_number' => $request->week_number,
            'file_pdf'    => $request->file_pdf,
            'data_pkl_id' => $dataPkl->id,
        ]);

        return new LogbookResource(true, 'Logbook berhasil ditambahkan', $data);
    }


    public function update(Request $request, $id)
    {
        $user = auth()->user();
        $logbook = Logbook::findOrFail($id);

        if ($user->role !== 'mahasiswa') {
            return response()->json(['success' => false, 'message' => 'Hanya mahasiswa yang bisa mengedit logbook'], 403);
        }

        // Pastikan mahasiswa hanya mengedit logbook miliknya
        $dataPkl = \App\Models\DataPkl::where('users_id', $user->id)->first();

        if (!$dataPkl || $logbook->data_pkl_id !== $dataPkl->id) {
            return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
        }

        $validator = Validator::make($request->all(), [
            'week_number' => 'sometimes|required|integer',
            'file_pdf'    => 'sometimes|required|string',
        ]);

        if ($validator->fails()) return response()->json($validator->errors(), 422);

        $logbook->update($request->only(['week_number', 'file_pdf']));

        return new LogbookResource(true, 'Logbook berhasil diperbarui', $logbook);
    }

    public function destroy($id)
    {
        $user = auth()->user();
        $logbook = Logbook::findOrFail($id);

        $dataPkl = \App\Models\DataPkl::where('users_id', $user->id)->first();

        if ($user->role !== 'mahasiswa' || !$dataPkl || $logbook->data_pkl_id !== $dataPkl->id) {
            return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
        }

        $logbook->delete();
        return new LogbookResource(true, 'Logbook berhasil dihapus', $logbook);
    }




}
