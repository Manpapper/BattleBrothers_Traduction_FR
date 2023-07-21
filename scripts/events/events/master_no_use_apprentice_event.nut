this.master_no_use_apprentice_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.master_no_use_apprentice";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%En vous promenant dans %townname%, vous rencontrez un vieil homme qui traîne un jeune homme par l\'oreille.%SPEECH_ON% Si tu veux devenir un maître, il faut du temps ! Du sang ! De la sueur ! Des larmes ! Si tu es du genre à pleurer et il n\'y a pas de honte à ça si tu pleures. Tiens, regarde ! Un mercenaire ! Si tu veux tant te battre, pourquoi ne pas aller le voir ? %SPEECH_OFF%Vous tendez les mains et demandez une explication avant qu\'il ne déblatère des inepties. Le vieil homme se calme et lâche l\'oreille du gamin.%SPEECH_ON%Oui, je suppose que tu as droit à une explication. Je suis le maître d\'armes de cette ville, mais j\'enseigne la discipline et la patience avant que quiconque ne touche une épée ! Et mon maudit élève n\'a ni l\'un ni l\'autre ! Alors je lui ai dit, si tu veux tant te battre, dégage !%SPEECH_OFF% Vous regardez le gamin. Il a un visage jeune, mais il y a effectivement une certaine impatience dans ses yeux. Vous lui demandez si ce que le maître d\'épée dit est vrai. Le gamin hoche la tête.%SPEECH_ON%Oui. Et je serais plus qu\'heureux de me battre pour vous, aussi.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "D\'accord, on le prend.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Non, merci. Il est tout à vous.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"apprentice_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Élève impatient d\'un maître d\'escrime et d\'épée, %name% n\'avait pas les aptitudes mentales pour s\'astreindre aux épreuves et aux tribulations pour devenir lui-même un maître de la lame. Mais ce qui lui manque en force mentale, il le compense largement en efforts. Vous l\'avez \"embauché\" simplement en le retirant des mains du vieil homme.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() <= 1)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"town",
			this.m.Town.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Town = null;
	}

});

