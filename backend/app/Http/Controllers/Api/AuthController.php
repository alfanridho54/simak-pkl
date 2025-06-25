<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
   public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name'     => 'required|string',
            'nim'      => 'required|string|unique:users,nim', 
            'email'    => 'required|email|unique:users,email',
            'password' => 'required|string|min:6',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'errors' => $validator->errors()], 422);
        }

        $user = User::create([
            'name'     => $request->name,
            'nim'      => $request->nim,
            'email'    => $request->email,
            'password' => Hash::make($request->password), 
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;
        return response()->json([
            "status"  => true,
            "message" => "Register Berhasil",
            "token"   => $token
        ], 201);
    }

    public function login (Request $request) {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|string|min:6'
        ]);
        $user = User::where('email', $request->email)->first();
        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                "status" => false,
                "message" => "Email atau Password salah"
            ], 401);
        }
        $token = $user->createToken('auth_token')->plainTextToken;
        return response()->json([
            "status" => true,
            "message" => "Login Berhasil",
            "token" => $token,
            "role" => $user->role
        ], 201);
    }
     
    public function logout (Request $request) {
        $request->user()->tokens()->delete();
        return response()->json([
            "status" => true,
            "message" => "Logout Berhasil"
        ], 200);
    }
}

