<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\LogbookResource;
use App\Models\Logbook;

class LogbookController extends Controller
{
    public function index()
    {
        $logbook = Logbook::all();

        foreach ($logbook as $item) {
            echo $item->id;
        }

        return new LogbookResource(true, 'List Data Logbook', $logbook);
    }
}
