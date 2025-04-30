<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\KomentarLogbookResource;
use App\Models\KomentarLogbook;

class KomentarLogbookController extends Controller
{
    public function index()
    {
        $komentar = KomentarLogbook::all();

        foreach ($komentar as $item) {
            echo $item->id;
        }

        return new KomentarLogbookResource(true, 'List Komentar Logbook', $komentar);
    }
}
