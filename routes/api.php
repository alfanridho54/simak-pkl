<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AbsenController;
use App\Http\Controllers\Api\DataPklController;
use App\Http\Controllers\Api\LaporanPklController;
use App\Http\Controllers\Api\LogbookController;
use App\Http\Controllers\Api\KomentarLaporanController;
use App\Http\Controllers\Api\KomentarLogbookController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\UserController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');



Route::get('/data-pkl', [DataPklController::class, 'index']);
Route::get('/absen', [AbsenController::class, 'index']);
Route::get('/laporan-pkl', [LaporanPklController::class, 'index']);
Route::get('/logbook', [LogbookController::class, 'index']);
Route::get('/komentar-laporan', [KomentarLaporanController::class, 'index']);
Route::get('/komentar-logbook', [KomentarLogbookController::class, 'index']);
Route::get('/notification', [NotificationController::class, 'index']);
Route::get('/user', [UserController::class, 'index']);