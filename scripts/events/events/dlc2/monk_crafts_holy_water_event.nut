this.monk_crafts_holy_water_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null
	},
	function create()
	{
		this.m.ID = "event.monk_crafts_holy_water";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%monk% le modeste moine entre dans votre tente avec une fiole à la main. La fiole est fermée par un bouchon d'écorce et d'une couronne de verdure avec des baies accrochées sous les feuilles. À l'intérieur de la fiole se trouve un liquide doré qui s'agite. Quoi qu'il en soit, le liquide attrape la moindre lueur et semble la capturer et la faire tourbillonner. Il vous la tend.%SPEECH_ON%De l'eau bénite, capitaine, pour combattre les morts qui marchent à nouveau.%SPEECH_OFF%Vous demandez si c'est un cadeau des anciens dieux. Il acquiesce. Vous demandez si c'est vraiment un cadeau des anciens dieux, cependant. Il se mordille les lèvres.%SPEECH_ON%Non, pas vraiment. Les monastères savent le faire, mais c'est une recette ancienne protégée sous peine de mort.%SPEECH_OFF%Bien sûr. Vous remerciez l'homme d'avoir pris le risque de contribuer et lui dites de mettre à jour l'inventaire.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Même les saints hommes ont des astuces.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				local item = this.new("scripts/items/tools/holy_water_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_monk = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk")
			{
				candidates_monk.push(bro);
			}
		}

		if (candidates_monk.len() == 0)
		{
			return;
		}

		this.m.Monk = candidates_monk[this.Math.rand(0, candidates_monk.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Monk = null;
	}

});

