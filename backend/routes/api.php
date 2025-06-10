<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;


use App\Http\Controllers\Api\AbsenController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DataPklController;
use App\Http\Controllers\Api\KomentarLaporanController;
use App\Http\Controllers\Api\KomentarLogbookController;
use App\Http\Controllers\Api\LaporanPklController;
use App\Http\Controllers\Api\LogbookController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\UserController;


// Rute Publik
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);


// Rute Terproteksi
Route::middleware('auth:sanctum')->group(function () {

    // Auth & User
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', fn(Request $request) => $request->user());
    Route::get('/users', [UserController::class, 'index'])->name('users.index'); // Untuk list dosen

    // Data PKL
    Route::get('/data-pkl/mahasiswa', [DataPklController::class, 'mahasiswaView']);
    Route::get('/data-pkl/dosen', [DataPklController::class, 'dosenView']);
    Route::apiResource('data_pkl', DataPklController::class);

    // Absensi
    Route::apiResource('absen', AbsenController::class);

    // Logbook
    Route::post('/logbook/{id}', [LogbookController::class, 'update']);
    // Rute apiResource untuk CRUD dasar (index, show, store, update, destroy)
    Route::apiResource('logbook', LogbookController::class);
    Route::get('/logbook/{id}/pdf', [LogbookController::class, 'exportPDF']);

    // Laporan PKL
    Route::apiResource('laporan-pkl', LaporanPklController::class);

    // Komentar (dengan middleware peran)
    Route::get('/komentar-logbook/by-logbook/{logbook_id}', [KomentarLogbookController::class, 'getByLogbook']);
    Route::get('/komentar-laporan/by-laporan/{laporan_pkl_id}', [KomentarLaporanController::class, 'getByLaporan']);
    Route::apiResource('komentar-logbook', KomentarLogbookController::class)->middleware('peran:admin,dosen');
    Route::apiResource('komentar-laporan', KomentarLaporanController::class)->middleware('peran:admin,dosen');

    // Rute Khusus Admin
    Route::middleware('peran:admin')->group(function () {
        Route::apiResource('user-management', UserController::class)->except(['index'])->parameters(['user-management' => 'user']);
        Route::apiResource('notification', NotificationController::class);
    });
});