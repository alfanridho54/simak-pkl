<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\NotificationResource;
use App\Models\Notification;

class NotificationController extends Controller
{
    public function index()
    {
        $notif = Notification::all();

        foreach ($notif as $item) {
            echo $item->id;
        }

        return new NotificationResource(true, 'List Notifikasi', $notif);
    }
}
