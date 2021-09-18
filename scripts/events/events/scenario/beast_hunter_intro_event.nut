this.beast_hunter_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.beast_hunters_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_124.png[/img]Vous avez rencontré l\'homme dans sa maison. Il vous a offert à manger, à boire, et le contrat en question. Tuez la sorcière de la forêt et vous serez payé en conséquence. Vous et vos hommes êtes partis et l\'avez fait, ramenant la tête de la sorcière.\n\nMais votre employeur n\'a fait que rire à votre retour. Il a dit que c\'était la sorcière qui l\'avait mis au pouvoir et que vous l\'aviez libéré de ses dettes envers elle, qu\'il avait été plus malin que vous et vos hommes stupides. Ses laquais sont sortis de l\'ombre, leurs épées déjà dégainées. L\'embuscade a commencé sur l\'arrogance du criminel et s\'est terminée avec sa tête dégagée de ses épaules. Mais elle a coûté la vie à beaucoup de vos compagnons tueurs de bêtes, et il ne reste que vous, %bs1%, %bs2% et %bs3%.\n\nLes monstres de ce monde sont souvent tenus à l\'écart : la cruauté des hommes se cache derrière une allégeance aveugle, les horreurs des bêtes derrière de sombres légendes. En tant que chef d\'une bande de tueurs de bêtes, il est devenu de plus en plus évident que vous ne pouvez plus faire la différence entre les deux. Si vous devez gagner de l\'argent en chassant des créatures, alors autant en rajouter en ajoutant l\'homme à la liste.",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "La bête la plus méchante est celle qui se croit la meilleure.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "The Beast Slayers";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"bs1",
			brothers[0].getNameOnly()
		]);
		_vars.push([
			"bs2",
			brothers[1].getNameOnly()
		]);
		_vars.push([
			"bs3",
			brothers[2].getNameOnly()
		]);
	}

	function onClear()
	{
	}

});

