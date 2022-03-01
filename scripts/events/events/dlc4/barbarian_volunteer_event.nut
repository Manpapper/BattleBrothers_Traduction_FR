this.barbarian_volunteer_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.barbarian_volunteer";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Contrairement au sud, trouver des voyageurs sur les \"routes\" du nord est souvent une cause de prudence. On ne sait jamais sur quel homme monstrueux ou quel barbare bestial on va tomber. Cette fois-ci, c\'est un grand homme qui boite avec un chien à ses côtés. Vous tirez votre épée à moitié hors de son fourreau et assez fort pour gagner son oreille. L\'homme lève les yeux et son chien se cabre au coup sec de la laisse. Le nordique peut parler un peu de votre langue.%SPEECH_ON%Ahh, des combattants. Je suis moi-même un combattant.%SPEECH_OFF%Vous lui demandez pourquoi il est seul. Il explique que son clan s\'est disputé et qu\'il devait affronter un autre homme en duel pour décider qui prendrait le contrôle. Vous lui demandez pourquoi il ne s\'est pas battu en duel avec cet homme, vous lui demandez s\'il a peur. Le voyageur secoue la tête.%SPEECH_ON%Non. Le membre du clan était mon frère. Et je n\'ai aucune envie de tuer un proche. Ils m\'ont donné cette chienne ici à la fois comme une insulte et une récompense et m\'ont jeté hors de la tribu. Je n\'ai ni terre ni peuple où aller, mais si vous voulez de moi, je me battrais pour vous aussi bien que n\'importe qui d\'autre.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous avez trouvé une nouvelle tribu, mon ami.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Nous n\'avons pas besoin de vous.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"barbarian_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% vous a rejoint après avoir été exilé de sa tribu dans le nord pour avoir refusé de tuer son frère. Il se battra pour vous aussi bien que pour n\'importe qui.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().equip(this.new("scripts/items/accessory/warhound_item"));
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.7)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() == "scenario.raiders")
		{
			this.m.Score = 20;
		}
		else
		{
			this.m.Score = 5;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

