<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\DataPklResource;
use App\Models\DataPkl;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;

class DataPklController extends Controller
{
    public function index()
    {
        $data = DataPkl::with(['mahasiswa', 'dosenPembimbing'])->latest()->get();

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
        $request->validate([
            'company_name' => 'required|string|max:255',
            'company_address' => 'required|string',
            'contact_person' => 'required|string|max:255',
            'dosen_pembimbing' => 'required|exists:users,id',
    
        ]);
    
        $data = DataPkl::create([
            'company_name' => $request->company_name,
            'company_address' => $request->company_address,
            'contact_person' => $request->contact_person,
            'dosen_pembimbing' => $request->dosen_pembimbing,
            'users_id' => Auth::id(),
        ]);
    
        return new DataPklResource(true, 'Data PKL berhasil ditambahkan', $data);
    }
    
    public function update(Request $request, $id)
    {
        $data = DataPkl::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'company_name'     => 'sometimes|required|string|max:255',
            'company_address'  => 'sometimes|required|string',
            'contact_person'   => 'sometimes|required|string|max:255',
            'dosen_pembimbing' => 'sometimes|required|exists:users,id',
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

     public function mahasiswaView()
    {
        $user = Auth::user();
        $data = DataPkl::with(['mahasiswa', 'dosenPembimbing'])
                       ->where('users_id', $user->id)
                       ->get();
        return new DataPklResource(true, 'Data PKL Mahasiswa', $data);
    }

    public function dosenView()
    {
        $user = Auth::user();
        $data = DataPkl::with(['mahasiswa', 'dosenPembimbing'])
                       ->where('dosen_pembimbing', $user->id)
                       ->get();
        return new DataPklResource(true, 'Data PKL untuk Dosen Pembimbing', $data);
    }
}

