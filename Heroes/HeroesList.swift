//
//  HeroesList.swift
//  Heroes
//
//  Created by Edoardo on 18/07/2021.
//


import SwiftUI
import Combine
import Kingfisher

// To hide the navigation bar
// from https://stackoverflow.com/a/60492133/436085
struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}
extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}
// To hide the navigation bar

// to hide the status bar
// from https://stackoverflow.com/a/64852835/436085
extension UIViewController {
    func prefersStatusBarHidden() -> Bool {
        return true
    }
}
// to hide the status bar


class HeroesViewModel: ObservableObject {
    @Published private(set) var state = State()
    private var subscriptions = Set<AnyCancellable>()
    
    func fetchNextPageIfPossible() {
        guard state.canLoadNextPage else { return }
        
        HeroesData.getHeroesResponse(page: state.page)
            .sink(receiveCompletion: onReceive,
                  receiveValue: onReceive)
            .store(in: &subscriptions)
    }
    
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure:
            state.canLoadNextPage = false
        }
    }

    private func onReceive(_ pageN: [Hero]) {
        state.heroesdata += pageN
        state.page += 1
        state.canLoadNextPage = pageN.count == HeroesData.pageSize
    }

    struct State {
        var heroesdata: [Hero] = []
        var page: Int = 1
        var canLoadNextPage = true
    }
}

struct HeroesListContainer: View {
    @ObservedObject var viewModel: HeroesViewModel
    
    var body: some View {
        HeroesList(
            heroes: viewModel.state.heroesdata,
            isLoading: viewModel.state.canLoadNextPage,
            onScrolledAtBottom: viewModel.fetchNextPageIfPossible
        )
        .onAppear(perform: viewModel.fetchNextPageIfPossible)
    }
}

struct HeroesList: View {
    let heroes: [Hero]
    let isLoading: Bool
    let onScrolledAtBottom: () -> Void

    var body: some View {
        NavigationView {
            List {
                heroesList
                if isLoading {
                    ProgressView("contacting API")
                        .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
                }
            }
        .hiddenNavigationBarStyle()
        }
    }
    
    private var heroesList: some View {
        ForEach(heroes) { hero in
            NavigationLink(destination: HeroDetail(hero: hero)) {
                HeroRow(hero: hero).onAppear {
                    if self.heroes.last == hero {
                        self.onScrolledAtBottom()
                    }
                }
            }
        }
        
    }
}

struct HeroRow: View {
    let hero: Hero
    
    var body: some View {
        VStack {
            KFImage(URL(string: "\(hero.thumbnail.path).\(hero.thumbnail.extension)")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            Text(hero.name).font(.title)
            Text("ID: \(hero.id)")
            hero.description.map(Text.init)?.font(.body)
        }
        .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}

struct HeroDetail: View {
    let hero: Hero
    var body: some View {
        GeometryReader { geometry in
            KFImage(URL(string: "\(hero.thumbnail.path).\(hero.thumbnail.extension)")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(width: geometry.size.width)
        }
        Text("\(hero.thumbnail.path) + \(hero.thumbnail.extension)")
Text(hero.name)
    .font(.title)
    

        VStack {

//            RoundedImage(imageName: hero.image!, size: 120).padding()
            Text(hero.name)
                .font(.title)
            Divider()
            VStack(alignment: .leading) {
                // HStack(alignment: .top) {
                //     Text("Job Title")
                //         .font(.subheadline)
                //         .bold()
                //     Spacer()
                //     Text(hero.jobTitleName)
                //         .font(.subheadline)
                // }.padding()
                HStack(alignment: .top) {
                    Text("Description")
                        .font(.subheadline)
                        .bold()
                    Spacer()
                    Text(hero.description!)
                        .font(.subheadline)
                }.padding()

            }
            Button("Press Me") {
                print("Pressed")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitle("")
//        .navigationBarHidden(true)
    }
}
