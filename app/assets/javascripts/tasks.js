$(document).on('click', '.edit_button', function(e) {
    e.preventDefault();
    $(this).hide();
    var form = $(this).closest('.edit_task');
    form.find('.task_name_field').prop('disabled', false);
    form.find('.save_button').show();
});
