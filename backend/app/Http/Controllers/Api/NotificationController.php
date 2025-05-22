<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\NotificationResource;
use App\Models\Notification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class NotificationController extends Controller
{
    public function index()
    {
        $data = Notification::all();
        return new NotificationResource(true, 'List Notifikasi', $data);
    }

    public function show($id)
    {
        $data = Notification::findOrFail($id);
        return new NotificationResource(true, 'Detail Notifikasi', $data);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'message'   => 'required|string',
            'status'    => 'required|in:read,unread',
            'users_id'  => 'required|exists:users,id',
        ]);

        if ($validator->fails()) return response()->json($validator->errors(), 422);

        $data = Notification::create($request->all());
        return new NotificationResource(true, 'Notifikasi Berhasil Ditambahkan', $data);
    }

    public function update(Request $request, $id)
    {
        $notif = Notification::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'message'   => 'sometimes|required|string',
            'status'    => 'sometimes|required|in:read,unread',
            'users_id'  => 'sometimes|required|exists:users,id',
        ]);

        if ($validator->fails()) return response()->json($validator->errors(), 422);

        $notif->update($request->all());
        return new NotificationResource(true, 'Notifikasi Berhasil Diupdate', $notif);
    }

    public function destroy($id)
    {
        $notif = Notification::findOrFail($id);
        $notif->delete();
        return new NotificationResource(true, 'Notifikasi Berhasil Dihapus', $notif);
    }


}
