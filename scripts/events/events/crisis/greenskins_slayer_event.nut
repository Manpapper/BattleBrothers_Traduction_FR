this.greenskins_slayer_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_slayer";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_35.png[/img]En marchant, un homme croise le chemin de %companyname%. Il est bien armé et semble plutôt chevaleresque à l\'exception d\'une caractéristique : un collier en os suspendu à son cou. A chaque pas, il claque avec un creux maladif contre sa cuirasse. Vous considérez cet étranger et ses ornements squelettiques avec prudence, de peur qu\'il ne fasse une ceinture avec votre sexe et une cuirasse avec votre...%SPEECH_ON%B\'soir, mercenaire.%SPEECH_OFF%Le guerrier salue. Il y a un poids invisible à cet homme, comme s\'il était entouré d\'un vide ou peut-être des âmes de ses victimes. Il hoche la tête et continue de parler.%SPEECH_ON%Vous semblez être du genre tueur de vert, et c\'est le genre de compagnie que je serais le plus enclin à rejoindre.%SPEECH_OFF%%randombrother% échange un regard avec vous et hausse les épaules . Il chuchote son indifférence.%SPEECH_ON%S\'il devient un problème, nous pouvons le gérer.%SPEECH_OFF%L\'homme secoue la tête.%SPEECH_ON%Oh, je ne serai pas un problème. Je veux juste tuer des orcs et des gobelins. Que devez-vous savoir de plus ? Une fois ces peaux vertes exterminés, je n\'aurai plus rien à faire avec vous.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Vous pourriez aussi bien nous rejoindre.",
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
					Text = "Non, merci, ça va.",
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
					"orc_slayer_background"
				]);
				_event.m.Dude.getSkills().add(this.new("scripts/skills/traits/hate_greenskins_trait"));
				local necklace = this.new("scripts/items/accessory/special/slayer_necklace_item");
				necklace.m.Name = " Collier de " + _event.m.Dude.getNameOnly() ;
				_event.m.Dude.getItems().equip(necklace);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 3000)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		this.m.Score = 10;
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

