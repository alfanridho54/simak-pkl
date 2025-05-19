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
        $table->unsignedBigInteger('data_pkl_id')->nullable()->after('id');

        $table->foreign('data_pkl_id')->references('id')->on('data_pkl')->onDelete('set null');
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
