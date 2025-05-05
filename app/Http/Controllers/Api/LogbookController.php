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
        $data = Logbook::all();
        return new LogbookResource(true, 'List Logbook', $data);
    }

    public function show($id)
    {
        $data = Logbook::find($id);
        return new LogbookResource(true, 'Detail Logbook', $data);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'week_number' => 'required|integer',
            'file_pdf'    => 'required|string',
            'data_pkl_id' => 'required|exists:data_pkl,id',
        ]);

        if ($validator->fails()) return response()->json($validator->errors(), 422);

        $data = Logbook::create($request->all());
        return new LogbookResource(true, 'Logbook Berhasil Ditambahkan', $data);
    }

    public function update(Request $request, $id)
    {
        $logbook = Logbook::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'week_number' => 'sometimes|required|integer',
            'file_pdf'    => 'sometimes|required|string',
            'data_pkl_id' => 'sometimes|required|exists:data_pkl,id',
        ]);

        if ($validator->fails()) return response()->json($validator->errors(), 422);

        $logbook->update($request->all());
        return new LogbookResource(true, 'Logbook Berhasil Diupdate', $logbook);
    }

    public function destroy($id)
    {
        $logbook = Logbook::find($id);
        $logbook->delete();
        return new LogbookResource(true, 'Logbook Berhasil Dihapus', $logbook);
    }

    public function createViaUrl(Request $request)
{
    $request->validate([
        'week_number' => 'required|numeric',
        'file_pdf' => 'required',
        'data_pkl_id' => 'required|exists:data_pkl,id'
    ]);

    $logbook = Logbook::create($request->query());
    return new LogbookResource(true, 'Logbook berhasil dibuat', $logbook);
}

}
