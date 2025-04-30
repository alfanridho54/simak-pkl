<?php

namespace App\Http\Controllers\Api;

use App\Http\Resources\AbsenResource;
use App\Models\Absen;
use Illuminate\Http\Request;

class AbsenController extends Controller
{    
    public function index()
    {
        // Mengambil semua data absen
        $absen = Absen::all();

        // Menggunakan foreach untuk mengakses id dari setiap item dalam koleksi
        foreach ($absen as $item) {
            echo $item->id;  // Akses id dari masing-masing item dalam koleksi
        }

        // Mengembalikan data dalam format JSON
        return new AbsenResource(true, 'List Data Absen', $absen);
    }
}
