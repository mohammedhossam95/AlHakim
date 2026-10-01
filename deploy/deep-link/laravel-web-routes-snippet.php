<?php

/**
 * Add to the Laravel site (alhakim-eg.com) routes/web.php
 *
 * Browser: redirects to homepage (no more 404).
 * Installed app: OS opens the app before this route runs (App Links).
 */

use Illuminate\Support\Facades\Route;

Route::get('/doctor/{doctorId}/book', function (string $doctorId) {
    return redirect()->to('https://alhakim-eg.com/', 302);
})->where('doctorId', '[a-zA-Z0-9\-]+');
