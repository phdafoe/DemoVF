//
//  ViewController.swift
//  TestVodafone
//
//  Created by Yago de Martin Lopez on 2/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    var userGuides: VFGUserGuides?
    var vc: VFGUserGuidesViewController!
    
    @IBAction func showUserGuides(_ sender: UIButton) {
        guard let userGuidesUnw = self.userGuides else { return }
        self.vc = VFGUserGuidesViewController(userGuides: userGuidesUnw)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userGuides = VFGUserGuides(initialPage: "0",
                                     pages: ["0" : VFGUserGuidesPage(pageId: "0",
                                                                  title: "!Nueva sección de averias¡",
                                                                  subtitle: "Desde ahora podrás gestionar tus incidencias de manera más fácil, rápida y efectiva",
                                                                  imageURL: URL(string: "https://assets-es.dxl.local.vodafone.es/mves/sites/vspain/image/3000005000578/averias_banner_desktop.jpg")!,
                                                                  details: "Resuelve tu avería de manera sencilla desde la app, desde ahora podrás gestionar tus incidencias de manera más fácil, rápida y efectiva",
                                                                  navigation: VFGUserGuidesNavigation(title: "siguiente",
                                                                                                   identifier: "1",
                                                                                                   type: .userguides)),
                                             "1" : VFGUserGuidesPage(pageId: "1",
                                                                  title: "Por ser de Vodafone",
                                                                  subtitle: "!Últimos días de ofertas¡\n regala a precios increíbles y págalos a plazos",
                                                                  imageURL: URL(string: "https://assets-es.dxl.local.vodafone.es/mves/sites/vspain/image/1500159648093/epcanje_mob.jpg")!,
                                                                  details: "Listado de dispositivos, Línea asociada, últimos días de ofertas¡\n regala a precios increíbles y págalos a plazos",
                                                                  navigation: VFGUserGuidesNavigation(title: "siguiente",
                                                                                                   identifier: "2",
                                                                                                   type: .userguides)),
                                             "2" : VFGUserGuidesPage(pageId: "2",
                                                                  title: "!Ya dispones de la mejor oferta¡",
                                                                  subtitle: "Si quieres seguir conociendo las últimas novedades, no te pierdas nuestras notificaciones",
                                                                  imageURL: URL(string: "https://assets-es.dxl.local.vodafone.es/mves/sites/vspain/image/1500152720304/ep_segline_mob.jpg")!,
                                                                  details: "!Ofertón¡ Línea ilimitada por 12,50€ mes y añade cascos de OPPO por 2€/mes más, Si quieres seguir conociendo las últimas novedades, no te pierdas nuestras notificaciones",
                                                                  navigation: VFGUserGuidesNavigation(title: "cerrar",
                                                                                                   identifier: "0",
                                                                                                   type: .app))])
    }
}

extension ViewController: VFGUserGuidesProtocol {
    
    func viewIsReady(userGuides: VFGUserGuides) {
        self.vc = VFGUserGuidesViewController(userGuides: userGuides)
    }
    
    func viewWillClose(userGuides: VFGUserGuides, page: VFGUserGuidesPage) {
        debugPrint(#function)
    }
    
    func sectionActionRequested(userGuides: VFGUserGuides, page: VFGUserGuidesPage) {
        debugPrint(#function)
    }
    
    func nextActionRequested(userGuides: VFGUserGuides, page: VFGUserGuidesPage) {
        debugPrint(#function)
    }
    
}

