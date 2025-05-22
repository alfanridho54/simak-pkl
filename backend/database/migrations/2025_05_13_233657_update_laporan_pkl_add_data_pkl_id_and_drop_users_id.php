<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
public function up()
    {
        Schema::table('laporan_pkl', function (Blueprint $table) {
            // Drop foreign key dan kolom lama jika masih ada
            if (Schema::hasColumn('laporan_pkl', 'users_id')) {
                try {
                    $table->dropForeign(['users_id']);
                } catch (\Throwable $e) {
                    // FK mungkin sudah tidak ada
                }
                $table->dropColumn('users_id');
            }

            // Tambahkan kolom data_pkl_id hanya jika belum ada
            if (!Schema::hasColumn('laporan_pkl', 'data_pkl_id')) {
                $table->unsignedBigInteger('data_pkl_id')->nullable();
                $table->foreign('data_pkl_id')->references('id')->on('data_pkl')->onDelete('cascade');
            }
        });
    }

    public function down()
    {
        Schema::table('laporan_pkl', function (Blueprint $table) {
            // Rollback perubahan
            if (Schema::hasColumn('laporan_pkl', 'data_pkl_id')) {
                $table->dropForeign(['data_pkl_id']);
                $table->dropColumn('data_pkl_id');
            }

            if (!Schema::hasColumn('laporan_pkl', 'users_id')) {
                $table->unsignedBigInteger('users_id')->nullable();
                $table->foreign('users_id')->references('id')->on('users')->onDelete('cascade');
            }
        });
    }

};
