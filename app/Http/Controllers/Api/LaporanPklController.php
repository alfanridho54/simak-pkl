<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\LaporanPklResource;
use App\Models\LaporanPkl;

class LaporanPklController extends Controller
{
    public function index()
    {
        $laporan = LaporanPkl::all();

        foreach ($laporan as $item) {
            echo $item->id;
        }

        return new LaporanPklResource(true, 'List Data Laporan PKL', $laporan);
    }
}
