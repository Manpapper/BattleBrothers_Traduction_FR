this.helped_caravan_event <- this.inherit("scripts/events/event", {
	m = {
		LastCombatID = 0
	},
	function create()
	{
		this.m.ID = "event.helped_caravan";
		this.m.Title = "After the battle...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Le chef de la caravane vient vous voir pour vous remercier de l\'avoir sauvé. Bien entendu, il ne se contente pas de mots : il vous offre un certain nombre de marchandises, dont certaines vous seront utiles. | %SPEECH_ON%Merci, mercenaire, merci!%SPEECH_OFF% Le maître marchand de la caravane joint ses mains et les secoue de haut en bas comme pour vous remercier et remercier les anciens dieux. Il remercie aussi avec des biens matériels, offrant à %companyname% un assortiment de récompenses directement issues des wagons. | Il est rare que des étrangers dans ce monde se voient de bonne grâce, mais même un marchand rusé comprend que s\'il est sauvé de l\'anéantissement total, il vaut peut-être mieux récompenser ses sauveurs. La caravane allège son chargement en vous récompensant avec un certain nombre de marchandises. | Si vous n\'étiez pas arrivé, cette caravane aurait sûrement connu la mort. Elle vous récompense comme il se doit pour vos services impromptus. | %SPEECH_ON%Par une puissance supérieure qui peut ou non exister pour vous, mais quelle qu\'elle soit, elle règne maintenant sur moi!%SPEECH_OFF% Le marchand est clairement sous le choc. Et, comme tout colporteur perturbé, il se tourne immédiatement vers la seule chose qu\'il sait faire.%SPEECH_ON%Ecoutez, nous avons des biens à offrir, que diriez-vous de ceci ? En témoignage de notre gratitude, tout cela gratuitement, bien sûr.%SPEECH_OFF%. | Bien que la bataille soit terminée, l\'hystérie des marchands sauvés est aussi forte que le carnage qui vient de se dérouler.%SPEECH_ON%Mercenaires, Mercenaires ! Nos sauveurs !%SPEECH_OFF%Soudainement, vous trouvez les marchands grouillant de marchandises pour vous remercier de les avoir sauvés.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Heureux d\'avoir pu vous aider.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local n = 1;

				if (this.World.Statistics.getFlags().getAsInt("LastCombatKills") > this.Math.rand(11, 14))
				{
					n = ++n;
				}

				for( local i = 0; i < n; i = ++i )
				{
					local item = this.new("scripts/items/" + this.World.Statistics.getFlags().get("LastCombatSavedCaravanProduce"));
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Vous recevez " + item.getName()
					});
				}
			}

		});
	}

	function isValid()
	{
		if (this.World.Statistics.getFlags().get("LastCombatSavedCaravan") && this.World.Statistics.getFlags().get("LastCombatWasOngoingBattle") && this.World.Statistics.getFlags().get("LastCombatID") > this.m.LastCombatID && this.World.Statistics.getFlags().getAsInt("LastCombatKills") >= this.Math.rand(4, 6))
		{
			this.m.LastCombatID = this.World.Statistics.getFlags().getAsInt("LastCombatID");
			return true;
		}

		return false;
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU32(this.m.LastCombatID);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 54)
		{
			this.m.LastCombatID = _in.readU32();
		}
	}

});

