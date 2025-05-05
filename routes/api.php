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



Route::get('/absen', [AbsenController::class, 'index']);
Route::get('/absen/{id}', [AbsenController::class, 'show']);
Route::post('/absen/create', [AbsenController::class, 'store']);
Route::put('/absen/update/{id}', [AbsenController::class, 'update']);


Route::get('/user', [UserController::class, 'index']);
Route::get('/user/{id}', [UserController::class, 'show']);
Route::post('/user/create', [UserController::class, 'store']);
Route::put('/user/update/{id}', [UserController::class, 'update']);
Route::delete('/user/delete/{id}', [UserController::class, 'destroy']);


Route::get('/data-pkl', [DataPklController::class, 'index']);
Route::get('/data-pkl/{id}', [DataPklController::class, 'show']);
Route::post('/data-pkl/create', [DataPklController::class, 'store']);
Route::put('/data-pkl/update/{id}', [DataPklController::class, 'update']);
Route::delete('/data-pkl/delete/{id}', [DataPklController::class, 'destroy']);

Route::get('/laporan-pkl', [LaporanPklController::class, 'index']);
Route::get('/laporan-pkl/{id}', [LaporanPklController::class, 'show']);
Route::post('/laporan-pkl/create', [LaporanPklController::class, 'store']);
Route::put('/laporan-pkl/update/{id}', [LaporanPklController::class, 'update']);
Route::delete('/laporan-pkl/delete/{id}', [LaporanPklController::class, 'destroy']);

Route::get('/logbook', [LogbookController::class, 'index']);
Route::get('/logbook/{id}', [LogbookController::class, 'show']);
Route::post('/logbook/create', [LogbookController::class, 'store']);
Route::put('/logbook/update/{id}', [LogbookController::class, 'update']);
Route::delete('/logbook/delete/{id}', [LogbookController::class, 'destroy']);

Route::get('/komentar-laporan', [KomentarLaporanController::class, 'index']);
Route::get('/komentar-laporan/{id}', [KomentarLaporanController::class, 'show']);
Route::post('/komentar-laporan/create', [KomentarLaporanController::class, 'store']);
Route::put('/komentar-laporan/update/{id}', [KomentarLaporanController::class, 'update']);
Route::delete('/komentar-laporan/delete/{id}', [KomentarLaporanController::class, 'destroy']);

Route::get('/komentar-logbook', [KomentarLogbookController::class, 'index']);
Route::get('/komentar-logbook/{id}', [KomentarLogbookController::class, 'show']);
Route::post('/komentar-logbook/create', [KomentarLogbookController::class, 'store']);
Route::put('/komentar-logbook/update/{id}', [KomentarLogbookController::class, 'update']);
Route::delete('/komentar-logbook/delete/{id}', [KomentarLogbookController::class, 'destroy']);

Route::get('/notification', [NotificationController::class, 'index']);
Route::get('/notification/{id}', [NotificationController::class, 'show']);
Route::post('/notification/create', [NotificationController::class, 'store']);
Route::put('/notification/update/{id}', [NotificationController::class, 'update']);
Route::delete('/notification/delete/{id}', [NotificationController::class, 'destroy']);
// Route::get('/list-dosen', [UserController::class, 'getListDosen']);

