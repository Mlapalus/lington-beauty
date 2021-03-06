<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class LogInController extends AbstractController
{
    public function index(): Response
    {
        return $this->render('pages/login.html.twig');
    }
}
