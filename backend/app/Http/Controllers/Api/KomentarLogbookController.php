<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\KomentarLogbookResource;
use App\Models\KomentarLogbook;
use App\Models\Logbook;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class KomentarLogbookController extends Controller
{
    public function index()
    {
        $user = Auth::user();

        if ($user->role === 'dosen') {
            // Ambil semua komentar logbook yang dibimbing dosen
            $data = KomentarLogbook::whereHas('logbook.dataPkl', function ($query) use ($user) {
                $query->where('dosen_pembimbing', $user->id);
            })->with(['logbook', 'logbook.dataPkl'])->get();

        } elseif ($user->role === 'mahasiswa') {
            // Ambil komentar logbook milik mahasiswa
            $data = KomentarLogbook::whereHas('logbook.dataPkl', function ($query) use ($user) {
                $query->where('users_id', $user->id);
            })->with(['logbook'])->get();

        } else {
            $data = KomentarLogbook::with(['logbook'])->get();
        }

        return new KomentarLogbookResource(true, 'List Komentar Logbook', $data);
    }

    public function store(Request $request)
    {
        $user = Auth::user();
        if ($user->role !== 'dosen') {
            return response()->json(['success' => false, 'message' => 'Hanya dosen yang dapat memberikan komentar'], 403);
        }

        $validator = Validator::make($request->all(), [
            'logbook_id' => 'required|exists:logbook,id',
            'comment'    => 'required|string',
        ]);

        if ($validator->fails()) return response()->json($validator->errors(), 422);

        // Cek apakah logbook ini dibimbing oleh dosen yang login
        $logbook = Logbook::with('dataPkl')->findOrFail($request->logbook_id);
        if ($logbook->dataPkl->dosen_pembimbing != $user->id) {
            return response()->json(['success' => false, 'message' => 'Anda bukan pembimbing logbook ini'], 403);
        }

        $data = KomentarLogbook::create([
            'logbook_id' => $request->logbook_id,
            'dosen_id'   => $user->id,
            'comment'    => $request->comment,
        ]);

        return new KomentarLogbookResource(true, 'Komentar Logbook berhasil ditambahkan', $data);
    }

    public function destroy($id)
    {
        $user = Auth::user();
        $komentar = KomentarLogbook::with('logbook.dataPkl')->findOrFail($id);

        // hanya dosen pembimbing yang bisa hapus komentar
        if ($user->role !== 'dosen' || $komentar->dosen_id !== $user->id) {
            return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
        }

        $komentar->delete();
        return new KomentarLogbookResource(true, 'Komentar Logbook berhasil dihapus', $komentar);
    }

    public function getByLogbook($logbook_id)
    {
        $komentar = KomentarLogbook::where('logbook_id', $logbook_id)
                    ->with('dosen')
                    ->get();

        return new KomentarLogbookResource(true, 'Komentar untuk Logbook ID: ' . $logbook_id, $komentar);
    }

}
