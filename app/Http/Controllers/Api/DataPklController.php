<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\DataPklResource;
use App\Models\DataPkl;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class DataPklController extends Controller
{
    public function index()
    {
        $data = DataPkl::join('users', 'data_pkl.dosen_pembimbing', '=', 'users.id')
        ->select('data_pkl.*', 'users.name as nama_dosen_pembimbing')
        ->get();
        return new DataPklResource(true, 'List Data PKL', $data);
    }

    public function show($id)
    {
        $data = DataPkl::join('users', 'data_pkl.dosen_pembimbing', '=', 'users.id')
        ->select('data_pkl.*', 'users.name as nama_dosen_pembimbing')
        ->find($id);
        return new DataPklResource(true, 'Detail Data PKL', $data);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'company_name'     => 'required|string|max:255',
            'company_address'  => 'required|string',
            'contact_person'   => 'required|string|max:255',
            'dosen_pembimbing' => 'required|exists:users,id',
            'status'           => 'required|in:pending,approved,rejected',
            'users_id'         => 'required|exists:users,id',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $data = DataPkl::create($request->all());
        return new DataPklResource(true, 'Data PKL Berhasil Ditambahkan', $data);
    }

    public function update(Request $request, $id)
    {
        $data = DataPkl::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'company_name'     => 'sometimes|required|string|max:255',
            'company_address'  => 'sometimes|required|string',
            'contact_person'   => 'sometimes|required|string|max:255',
            'dosen_pembimbing' => 'sometimes|required|exists:users,id',
            'status'           => 'sometimes|required|in:pending,approved,rejected',
            'users_id'         => 'sometimes|required|exists:users,id',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $data->update($request->all());
        return new DataPklResource(true, 'Data PKL Berhasil Diubah', $data);
    }

    public function destroy($id)
    {
        $data = DataPkl::findOrFail($id);
        $data->delete();
        return new DataPklResource(true, 'Data PKL Berhasil Dihapus', $data);
    }

    public function createViaUrl(Request $request)
{
    $request->validate([
        'company_name' => 'required',
        'company_address' => 'required',
        'contact_person' => 'required',
        'dosen_pembimbing' => 'required|exists:users,id',
        'status' => 'required',
        'users_id' => 'required|exists:users,id'
    ]);

    $data = DataPkl::create($request->query());
    return new DataPklResource(true, 'Data PKL berhasil dibuat', $data);
}


}
