document.addEventListener('DOMContentLoaded', function() {
  const modal = document.getElementById('savePinModal');
  if (modal) {
    // Close modal when clicking outside
    modal.addEventListener('click', function(e) {
      if (e.target === modal) {
        modal.style.display = 'none';
      }
    });
  }
});
