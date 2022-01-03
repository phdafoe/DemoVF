//
//  ViewController.swift
//  TestVodafone
//
//  Created by Yago de Martin Lopez on 2/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    var userGuides: UserGuides?
    var vc: VFUserGuidesViewController!
    
    @IBAction func showUserGuides(_ sender: UIButton) {
        guard let userGuidesUnw = self.userGuides else { return }
        self.vc = VFUserGuidesViewController(userGuides: userGuidesUnw)
        vc.delegate = self
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userGuides = UserGuides(initialPage: "0",
                                     pages: ["0" : UserGuidesPage(pageId: "0",
                                                                  title: "!Nueva sección de averias¡",
                                                                  subtitle: "Desde ahora podrás geswtionar tus incidencias de manera más fácil, rápida y efectiva",
                                                                  imageURL: URL(string: "https://assets-es.dxl.local.vodafone.es/mves/sites/vspain/image/3000005000578/averias_banner_desktop.jpg")!,
                                                                  details: "Resuelve tu avería de maneta sencilla desde la app",
                                                                  navigation: UserGuidesNavigation(title: "siguiente",
                                                                                                   identifier: "1",
                                                                                                   type: .userguides)),
                                             "1" : UserGuidesPage(pageId: "1",
                                                                  title: "Por ser de Vodafone",
                                                                  subtitle: "!Últimos días de ofertas¡\n regala a precios increíbles y págalos a plazos",
                                                                  imageURL: URL(string: "https://assets-es.dxl.local.vodafone.es/mves/sites/vspain/image/1500159648093/epcanje_mob.jpg")!,
                                                                  details: "Listado de dispositivos, Línea asociada",
                                                                  navigation: UserGuidesNavigation(title: "siguiente",
                                                                                                   identifier: "2",
                                                                                                   type: .userguides)),
                                             "2" : UserGuidesPage(pageId: "2",
                                                                  title: "!Ya dispones de la mejor oferta¡",
                                                                  subtitle: "Si quieres seguir conociendo las últimas novedades, no te pierdas nuestras notificaciones",
                                                                  imageURL: URL(string: "https://assets-es.dxl.local.vodafone.es/mves/sites/vspain/image/1500152720304/ep_segline_mob.jpg")!,
                                                                  details: "!Ofertón¡ Línea ilimitada por 12,50€ mes y añade cascos de OPPO por 2€/mes más",
                                                                  navigation: UserGuidesNavigation(title: "cerrar",
                                                                                                   identifier: "0",
                                                                                                   type: .app))])
    }


}

extension ViewController: VFUserGuidesProtocol {
    
    func viewIsReady(userGuides: UserGuides) {
        self.vc = VFUserGuidesViewController(userGuides: userGuides)
    }
    
    func viewWillClose(userGuides: UserGuides, page: UserGuidesPage) {
        //
    }
    
    func sectionActionRequested(userGuides: UserGuides, page: UserGuidesPage) {
        //
    }
    
    func nextActionRequested(userGuides: UserGuides, page: UserGuidesPage) {
        //
    }
    
    
}

