<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Rules\Password;

class UserController extends Controller
{

    public function index(Request $request)
    {
     
        if ($request->has('role')) {
            $users = User::where('role', $request->role)->get();
        } else {
            $users = User::all();
        }

        return response()->json([
            'success' => true,
            'message' => 'Daftar Pengguna berhasil diambil',
            'data'    => $users
        ]);
    }


    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name'     => 'required|string|max:255',
            'email'    => 'required|string|email|max:255|unique:users',
            'role'     => 'required|string|in:admin,dosen,mahasiswa',
            'password' => ['required', 'string', Password::min(8)->mixedCase()->numbers()],
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $user = User::create([
            'name'     => $request->name,
            'email'    => $request->email,
            'role'     => $request->role,
            'password' => Hash::make($request->password),
        ]);

        return response()->json(['success' => true, 'message' => 'Pengguna berhasil dibuat', 'data' => $user], 201);
    }


    public function show(User $user)
    {
        return response()->json(['success' => true, 'message' => 'Detail Pengguna', 'data' => $user]);
    }

 
    public function update(Request $request, User $user)
    {
        $validator = Validator::make($request->all(), [
            'name'     => 'sometimes|required|string|max:255',
            'email'    => ['sometimes', 'required', 'string', 'email', 'max:255', Rule::unique('users')->ignore($user->id)],
            'role'     => 'sometimes|required|string|in:admin,dosen,mahasiswa',
            'password' => ['nullable', 'string', Password::min(8)->mixedCase()->numbers()],
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $user->name = $request->input('name', $user->name);
        $user->email = $request->input('email', $user->email);
        $user->role = $request->input('role', $user->role);

      
        if ($request->filled('password')) {
            $user->password = Hash::make($request->password);
        }

        $user->save();

        return response()->json(['success' => true, 'message' => 'Pengguna berhasil diperbarui', 'data' => $user]);
    }

    public function destroy(User $user)
    {
       
        if ($user->id === auth()->id()) {
            return response()->json(['success' => false, 'message' => 'Anda tidak dapat menghapus akun Anda sendiri.'], 403);
        }

        $user->delete();

        return response()->json(['success' => true, 'message' => 'Pengguna berhasil dihapus']);
    }
}