<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\DataPkl;
use App\Models\Logbook;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class DashboardController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        $data = [];

        if ($user->role === 'mahasiswa') {
            $dataPkl = DataPkl::with(['dosenPembimbing'])->where('users_id', $user->id)->first();

            $data = [
                'company_name' => $dataPkl->company_name ?? 'Belum terdaftar',
                'dosen_pembimbing' => $dataPkl->dosenPembimbing->name ?? 'Belum ditentukan',
                'total_logbook' => Logbook::where('data_pkl_id', $dataPkl->id ?? 0)->count(),
            ];
        } 
        elseif ($user->role === 'dosen') {
            $mahasiswaIds = DataPkl::where('dosen_pembimbing', $user->id)->pluck('users_id');

            $latest_activities = Logbook::with('dataPkl.mahasiswa')
                ->whereHas('dataPkl', function ($query) use ($user) {
                    $query->where('dosen_pembimbing', $user->id);
                })
                ->latest()
                ->take(5)
                ->get();

            $data = [
                'jumlah_bimbingan' => count($mahasiswaIds),
                'logbook_baru' => Logbook::whereIn('data_pkl_id', DataPkl::where('dosen_pembimbing', $user->id)->pluck('id'))->count(),
                'latest_activities' => $latest_activities,
            ];
        } 
        elseif ($user->role === 'admin') {
            $data = [
                'total_users' => User::count(),
                'total_mahasiswa' => User::where('role', 'mahasiswa')->count(),
                'total_dosen' => User::where('role', 'dosen')->count(),
            ];
        }

        return response()->json([
            'success' => true,
            'message' => 'Data dashboard berhasil diambil',
            'data' => $data,
        ]);
    }
}

