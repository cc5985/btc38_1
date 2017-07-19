
def test(message)
  p 'test '+ message + '-'*(80-5-message.to_s.length)
  yield
  p '-'*80
  p
  p

end