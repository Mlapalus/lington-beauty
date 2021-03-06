<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class LogOutController extends AbstractController
{
    #[Route('/log/out', name: 'log_out')]
    public function index(): Response
    {
        return $this->render('pages/logout.html.twig');
    }
}
