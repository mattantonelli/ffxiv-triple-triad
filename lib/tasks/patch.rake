namespace :patch do
  desc 'Set card patch values'
  task set: :environment do
    puts 'Setting card patch values'

    Card.where(id: 1..80).update(patch: '2.51')
    Card.where(id: 81..100).update(patch: '3.0')
    Card.where(id: 101..120).update(patch: '3.1')
    Card.where(id: 121..140).update(patch: '3.2')
    Card.where(id: 141..153).update(patch: '3.3')
    Card.where(id: 154..168).update(patch: '3.4')
    Card.where(id: 169..182).update(patch: '3.5')
    Card.where(id: 173..181).update(patch: '3.55a')
    Card.where(id: 183..202).update(patch: '4.0')
    Card.where(id: 203..210).update(patch: '4.1')
    Card.where(id: 211..220).update(patch: '4.2')
    Card.where(id: 224..230).update(patch: '4.3')
    Card.where(id: 221..225).update(patch: '4.35')
    Card.where(id: 223..227).update(patch: '4.36')
    Card.where(id: 232..240).update(patch: '4.4')
    Card.where(id: 231..239).update(patch: '4.45')
    Card.where(id: 241..251).update(patch: '4.5')
    Card.where(id: 242..245).update(patch: '4.55')
  end
end
