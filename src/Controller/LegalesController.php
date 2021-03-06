<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class LegalesController extends AbstractController
{
    #[Route('/legales', name: 'legales')]
    public function index(): Response
    {
        return $this->render('pages/legales.html.twig');
    }
}
