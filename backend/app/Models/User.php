<?php

// app/Models/User.php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasFactory, Notifiable, HasApiTokens;

    protected $fillable = [
        'name','nim', 'email', 'password', 'role','avatar'
    ];

    protected $hidden = [
        'password', 'remember_token',
    ];

    protected function avatar(): Attribute
    {
        return Attribute::make(
            get: fn ($value) => $value ? Storage::disk('public')->url($value) : null,
        );
    }

    public function dataPkl()
    {
        return $this->hasOne(DataPkl::class, 'users_id');
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

