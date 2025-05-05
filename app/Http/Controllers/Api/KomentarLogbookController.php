<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\KomentarLogbookResource;
use App\Models\KomentarLogbook;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class KomentarLogbookController extends Controller
{
    public function index()
    {
        $data = KomentarLogbook::all();
        return new KomentarLogbookResource(true, 'List Komentar Logbook', $data);
    }

    public function show($id)
    {
        $data = KomentarLogbook::findOrFail($id);
        return new KomentarLogbookResource(true, 'Detail Komentar Logbook', $data);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'logbook_id' => 'required|exists:logbook,id',
            'dosen_id'   => 'required|exists:users,id',
            'comment'    => 'required|string',
        ]);

        if ($validator->fails()) return response()->json($validator->errors(), 422);

        $data = KomentarLogbook::create($request->all());
        return new KomentarLogbookResource(true, 'Komentar Logbook Berhasil Ditambahkan', $data);
    }

    public function update(Request $request, $id)
    {
        $komentar = KomentarLogbook::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'logbook_id' => 'sometimes|required|exists:logbook,id',
            'dosen_id'   => 'sometimes|required|exists:users,id',
            'comment'    => 'sometimes|required|string',
        ]);

        if ($validator->fails()) return response()->json($validator->errors(), 422);

        $komentar->update($request->all());
        return new KomentarLogbookResource(true, 'Komentar Logbook Berhasil Diupdate', $komentar);
    }

    public function destroy($id)
    {
        $komentar = KomentarLogbook::findOrFail($id);
        $komentar->delete();
        return new KomentarLogbookResource(true, 'Komentar Logbook Berhasil Dihapus', $komentar);
    }

}
