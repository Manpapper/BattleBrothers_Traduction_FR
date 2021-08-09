this.houndmaster_tames_wolf_event <- this.inherit("scripts/events/event", {
	m = {
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.houndmaster_tames_wolf";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_143.png[/img]En traversant les terres désolées et enneigées du nord du royaume, %houndmaster% le maître des chiens s\'est lié d\'amitié avec une créature qui suivait la marche de la compagnie : un loup. Le maître des chiens restait souvent à l\'arrière, accroupi, les mains sur le côté, fixant le loup pendant de longues minutes. Mais aujourd\'hui, avec un peu de viande restante, il a mené la bête jusqu\'au milieu du camp. Maintenant, il s\'accroupit à ses côtés, rapetissé par son garrot proéminent et musclé, ses oreilles pointues et attentives, et sa gueule bordée de canines tueuses d\'hommes.\n\n Le reste des hommes se tiennent derrière leurs armes. L\'un d\'eux crie au maître des chiens d\'arrêter ce qu\'il fait. Un autre dit que le loup peut sentir la peur. Un autre encore lui jette une pierre. Le loup grimace, mais ne réagit pas. En riant, le maître-chien fait un bruit de \"tssst !\" et pointe du doigt. Le loup s\'élance en avant, ramasse la pierre et la ramène à l\'homme. Il frotte la crinière de la bête. %SPEECH_ON%Regardez, facile à dresser, comme n\'importe quel chien. Mais plus gros, plus rapide et plus fort. Plus malin aussi%SPEECH_OFF%. Ses yeux rencontrent les vôtres. Le loup se couche à terre, presque comme un homme qui s\'incline. %houndmaster% rit à nouveau.%SPEECH_ON%Vous voyez ? Il sait déjà qui est l\'alpha de cette meute.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Une noble bête.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				local item = this.new("scripts/items/accessory/wolf_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				_event.m.Houndmaster.improveMood(2.0, "A réussi à apprivoiser un loup");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Houndmaster.getMoodState()],
					text = _event.m.Houndmaster.getName() + this.Const.MoodStateEvent[_event.m.Houndmaster.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Snow)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 5 && bro.getBackground().getID() == "background.houndmaster")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Houndmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 6;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"houndmaster",
			this.m.Houndmaster.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Houndmaster = null;
	}

});

