this.undead_crusader_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_crusader";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_35.png[/img]Un homme en armure vous arrête sur le chemin. Vous mettez la main à votre épée et lui ordonnez d\'annoncer ses intentions, tout en gardant les yeux attentifs à une embuscade. L\'étranger fait un pas en avant et retire son heaume.%SPEECH_ON%Je suis %crusader%, combattant d\'un pays ardent sans nom. Je me suis tenu sur les collines du conseil maudit. J\'ai tué les monstres de Dev\'ungrad. J\'ai donné la paix aux esprits à Shellstaya. Quand les anciens parlent, j\'écoute. Et donc me voici.%SPEECH_OFF%Vous enlevez la main de votre épée et demandez qui sont les anciens. Il hoche la tête et répond.%SPEECH_ON%Les hommes avant les hommes, les anciens étaient suzerains de toutes choses, ayant forgé un empire qui s\'étendait bien au-delà de celui-ci. Tout ce chaos n\'est que des fragments de leur destruction. Un homme peut mourir, mais pas un empire. Un empire se décompose, morceau par morceau, et emporte avec lui tout ce qu\'il pense lui être dû.%SPEECH_OFF%Le croisé remet son casque et lève son épée.%SPEECH_ON%L\'Empire des Anciens s\'agite dans sa tombe. Je souhaite aider à le calmer. Je t\'offre mon épée, mercenaire.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Vous pouvez nous rejoindre.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Non merci, ça va.",
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
					"crusader_background"
				]);
				_event.m.Dude.getSkills().add(this.new("scripts/skills/traits/hate_undead_trait"));
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isUndeadScourge())
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
		_vars.push([
			"crusader",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

