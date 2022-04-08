this.greenskins_slayer_leaves_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_slayer_leaves";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_35.png[/img]%orcslayer% le tueur d\'orcs s\'approche de vous.%SPEECH_ON%Eh bien, je suppose que c\'est tout alors. Il n\'y a plus autant d\'orcs et de gobelins à tuer. Je te dis adieu, mercenaire.%SPEECH_OFF%Vous demandez ce qu\'il va faire. Il enlève son armure et la pose par terre devant vous.%SPEECH_ON%Ma famille a été vengée.%SPEECH_OFF%Vous hochez la tête et lui souhaitez bonne chance maintenant que ses démons intérieurs ont été apaisés. Il rit.%SPEECH_ON%Je plaisante. Je n\'ai pas de famille. J\'ai tué ces salauds parce que j\'aimais leur vider les tripes, mais mon cœur n\'y est plus. Envoyez mes salutations au reste des hommes.%SPEECH_OFF%Et sur ce, le tueur d\'orcs, ou l\'ancien tueur d\'orcs, quitta la compagnie.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Adieu!",
					function getResult( _event )
					{
						_event.m.Dude.getItems().transferToStash(this.World.Assets.getStash());
						_event.m.Dude.getSkills().onDeath(this.Const.FatalityType.None);
						this.World.getPlayerRoster().remove(_event.m.Dude);
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Dude.getName() + " quitte " + this.World.Assets.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.FactionManager.isGreenskinInvasion())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() == 1)
		{
			return;
		}

		local slayer;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.orc_slayer")
			{
				slayer = bro;
				break;
			}
		}

		if (slayer == null)
		{
			return;
		}

		this.m.Dude = slayer;
		this.m.Score = 100;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"orcslayer",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

