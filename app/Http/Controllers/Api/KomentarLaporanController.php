<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\KomentarLaporanResource;
use App\Models\KomentarLaporan;

class KomentarLaporanController extends Controller
{
    public function index()
    {
        $komentar = KomentarLaporan::all();

        foreach ($komentar as $item) {
            echo $item->id;
        }

        return new KomentarLaporanResource(true, 'List Komentar Laporan', $komentar);
    }
}
