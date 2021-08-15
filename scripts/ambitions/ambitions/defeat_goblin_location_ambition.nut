this.defeat_goblin_location_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		Defeated = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_goblin_location";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Seuls les plus audacieux s\'attaquent aux gobelins en grand nombre. Nous brûlerons quelques-uns de leurs campements fétides, et la nouvelle circulera !";
		this.m.RewardTooltip = "Vous recevrez un accessoire unique qui rendra son porteur insensible à l\'enracinement.";
		this.m.UIText = "Détruire les lieux contrôlés par les gobelins";
		this.m.TooltipText = "Détruisez quatre lieux contrôlés par des gobelins pour prouver les prouesses de la compagnie, que ce soit dans le cadre d\'un contrat ou par vous même. Vous aurez également besoin d\'assez de place dans votre inventaire pour un nouvel objet.";
		this.m.SuccessText = "[img]gfx/ui/events/event_83.png[/img]Les hommes sont éparpillés sur le champ de bataille, respirant encore lourdement après un dur combat. Pendant que vous arpentez le terrain, %randombrother% et %randombrother2% le fouillent à la recherche d\'objets de valeur.%SPEECH_ON% Nous avançons, ils reculent. Nous nous retirons, ils nous harcèlent. Tirez une volée de flèches et ils se mettent à l\'abri. Un mur de bouclier est transpercé de lames empoisonnées, et à la charge, ils se dispersent comme des insectes. Ces maudites choses qu\'ils vous lancent voleront dans mes rêves dans les nuits à venir.%SPEECH_OFF%%randombrother2% pique un gobelin mort avec son arme, et, satisfait qu\'il soit bien mort, s\'agenouille pour regarder de plus près ses affaires. Mais plus le combat est amer, plus la victoire est douce.%SPEECH_OFF% Il se lève et croise le regard de %randombrother%. %SPEECH_ON% Plus le combat est amer, plus je me sens vivant. Viens.%SPEECH_OFF%Ils continuent lentement à rejoindre le reste des hommes, s\'arrêtant ici et là pour chercher des choses qui valent une couronne ou deux avant que la compagnie s\'éloigne vers une nouvelle ville.";
		this.m.SuccessButtonText = "Victoire !";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.m.Defeated + "/4)";
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.FactionManager.getFaction(_location.getFaction()).getType() == this.Const.FactionType.Goblins)
		{
			++this.m.Defeated;
			this.World.Ambitions.updateUI();
		}
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 20)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 2 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return false;
		}

		if (this.m.Defeated >= 4)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"recently_destroyed",
			this.World.Statistics.getFlags().get("LastLocationDestroyedName")
		]);
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		item = this.new("scripts/items/accessory/goblin_trophy_item");
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
	}

	function onClear()
	{
		this.m.Defeated = 0;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU8(this.m.Defeated);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.Defeated = _in.readU8();
	}

});

