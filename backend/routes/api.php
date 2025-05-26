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
use App\Http\Controllers\Api\AuthController;
use App\Http\Middleware\Peran;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware(['auth:sanctum', 'peran:admin'])->group(function () {
    
    Route::get('/user/{id}', [UserController::class, 'show']);
    Route::post('/user/create', [UserController::class, 'store']);
    Route::put('/user/update/{id}', [UserController::class, 'update']);
    Route::delete('/user/delete/{id}', [UserController::class, 'destroy']);
    Route::get('/notification/{id}', [NotificationController::class, 'show']);
    Route::post('/notification/create', [NotificationController::class, 'store']);
    Route::put('/notification/update/{id}', [NotificationController::class, 'update']);
    Route::delete('/notification/delete/{id}', [NotificationController::class, 'destroy']);
});



Route::get('/absen/{id}', [AbsenController::class, 'show']);
Route::middleware(['auth:sanctum', 'peran:mahasiswa'])->post('/absen/create', [AbsenController::class, 'store']);
Route::put('/absen/update/{id}', [AbsenController::class, 'update']);



Route::get('/data-pkl', [DataPklController::class, 'index']);
Route::middleware(['auth:sanctum', 'peran:mahasiswa'])->group(function () {
    Route::get('/data-pkl/mahasiswa', [DataPklController::class, 'mahasiswaView']);
    Route::post('/data-pkl/create', [DataPklController::class, 'store']);
    Route::post('/laporan-pkl/create', [LaporanPklController::class, 'store']);
    Route::put('/laporan-pkl/update/{id}', [LaporanPklController::class, 'update']);
    Route::delete('/laporan-pkl/delete/{id}', [LaporanPklController::class, 'destroy']);
    Route::post('/logbook/create', [LogbookController::class, 'store']);
    Route::put('/logbook/update/{id}', [LogbookController::class, 'update']);
    Route::delete('/logbook/delete/{id}', [LogbookController::class, 'destroy']);

});
Route::middleware(['auth:sanctum', 'peran:dosen'])->get('/data-pkl/dosen', [DataPklController::class, 'dosenView']);
Route::get('/data-pkl/{id}', [DataPklController::class, 'show']);
Route::put('/data-pkl/update/{id}', [DataPklController::class, 'update']);
Route::delete('/data-pkl/delete/{id}', [DataPklController::class, 'destroy']);


Route::middleware(['auth:sanctum'])->group(function () {
    Route::get('/komentar-laporan', [KomentarLaporanController::class, 'index']);
    Route::get('/komentar-logbook', [KomentarLogbookController::class, 'index']);
    Route::get('/absen', [AbsenController::class, 'index']);
    Route::get('/logbook', [LogbookController::class, 'index']);
    Route::get('/laporan-pkl', [LaporanPklController::class, 'index']);
    Route::get('/komentar-logbook/by-logbook/{logbook_id}', [KomentarLogbookController::class, 'getByLogbook']);
    Route::get('/komentar-laporan/by-laporan/{laporan_pkl_id}', [KomentarLaporanController::class, 'getByLaporan']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', function (Request $request) {
        return $request->user(); 
    });
});
Route::get('/laporan-pkl/{id}', [LaporanPklController::class, 'show']);


Route::get('/logbook/{id}', [LogbookController::class, 'show']);



Route::get('/notification', [NotificationController::class, 'index']);

Route::group(['middleware' => ['auth:sanctum', 'peran:admin-dosen']], function () {
    Route::get('/komentar-laporan/{id}', [KomentarLaporanController::class, 'show']);
    Route::post('/komentar-laporan/create', [KomentarLaporanController::class, 'store']);
    Route::put('/komentar-laporan/update/{id}', [KomentarLaporanController::class, 'update']);
    Route::delete('/komentar-laporan/delete/{id}', [KomentarLaporanController::class, 'destroy']);
    Route::get('/komentar-logbook/{id}', [KomentarLogbookController::class, 'show']);
    Route::post('/komentar-logbook/create', [KomentarLogbookController::class, 'store']);
    Route::put('/komentar-logbook/update/{id}', [KomentarLogbookController::class, 'update']);
    Route::delete('/komentar-logbook/delete/{id}', [KomentarLogbookController::class, 'destroy']);
});


// Route::get('/list-dosen', [UserController::class, 'getListDosen']);

