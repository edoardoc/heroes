//
//  HeroesList.swift
//  Heroes
//
//  Created by Edoardo on 18/07/2021.
//


import SwiftUI
import Combine

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
        List {
            heroesList
            if isLoading {
                ProgressView("contacting API")
                    .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    private var heroesList: some View {
        ForEach(heroes) { hero in
            HeroRow(hero: hero).onAppear {
                if self.heroes.last == hero {
                    self.onScrolledAtBottom()
                }
            }
        }
    }
    
}

struct HeroRow: View {
    let hero: Hero
    
    var body: some View {
        VStack {
            Text(hero.name).font(.title)
            Text("⭐️ \(hero.id)")
            hero.description.map(Text.init)?.font(.body)
        }
        .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}
