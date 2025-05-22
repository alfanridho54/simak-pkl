<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
Schema::table('laporan_pkl', function (Blueprint $table) {
    $table->unsignedBigInteger('users_id')->after('data_pkl_id')->nullable();

    $table->foreign('users_id')->references('id')->on('users')->onDelete('cascade');
});

    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('laporan_pkl', function (Blueprint $table) {
            //
        });
    }
};
