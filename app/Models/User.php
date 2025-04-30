<?php

// app/Models/User.php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    use HasFactory, Notifiable;

    protected $fillable = [
        'name', 'email', 'password', 'role'
    ];

    protected $hidden = [
        'password', 'remember_token',
    ];

    public function dataPkl()
    {
        return $this->hasMany(DataPkl::class, 'users_id');
    }

    public function laporanPkl()
    {
        return $this->hasMany(LaporanPkl::class, 'users_id');
    }

    public function komentarLaporan()
    {
        return $this->hasMany(KomentarLaporan::class, 'dosen_id');
    }

    public function komentarLogbook()
    {
        return $this->hasMany(KomentarLogbook::class, 'dosen_id');
    }

    public function notifications()
    {
        return $this->hasMany(Notification::class, 'users_id');
    }
}

