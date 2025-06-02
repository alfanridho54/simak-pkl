<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function index()
    {
        $data = User::all();
        return new UserResource(true, 'List Data User', $data);
    }

    public function show($id)
    {
        $data = User::find($id);
        return new UserResource(true, 'Detail Data User', $data);
    }

    public function store(Request $request)
    {
        $data = User::create($request->all());
        return new UserResource(true, 'Data User Berhasil Ditambahkan', $data);
    }

    public function update(Request $request, $id)
    {
        $data = User::find($id);
        $data->update($request->all());
        return new UserResource(true, 'Data User Berhasil Diubah', $data);
    }

    public function destroy($id)
    {
        $data = User::find($id);
        $data->delete();
        return new UserResource(true, 'Data User Berhasil Dihapus', $data);
    }

    public function getDosenList()
    {
        $data = User::where('role', 'dosen')->get();
        return new UserResource(true, 'List Data Dosen', $data);
    }

    

}
