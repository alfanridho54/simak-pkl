<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\DataPklResource;
use App\Models\DataPkl;

class DataPklController extends Controller
{
    public function index()
    {
        $data = DataPkl::all();

        foreach ($data as $item) {
            echo $item->id;
        }

        return new DataPklResource(true, 'List Data PKL', $data);
    }
}
